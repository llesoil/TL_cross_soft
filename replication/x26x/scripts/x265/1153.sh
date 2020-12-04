#!/bin/sh

numb='1154'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 20 --keyint 290 --lookahead-threads 4 --min-keyint 26 --qp 0 --qpstep 3 --qpmin 4 --qpmax 64 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,3.0,1.2,1.2,1.6,0.5,0.7,0.7,3,1,16,20,290,4,26,0,3,4,64,38,3,1000,-1:-1,dia,show,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"