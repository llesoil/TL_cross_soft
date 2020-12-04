#!/bin/sh

numb='349'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 1.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 45 --keyint 230 --lookahead-threads 3 --min-keyint 30 --qp 20 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.0,1.0,1.1,1.4,0.4,0.7,0.8,2,0,8,45,230,3,30,20,5,4,68,28,6,2000,-2:-2,dia,show,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"