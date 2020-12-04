#!/bin/sh

numb='1528'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 1.0 --qblur 0.5 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 5 --keyint 300 --lookahead-threads 1 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 2 --qpmax 63 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.0,1.5,1.1,1.0,0.5,0.9,0.1,3,1,8,5,300,1,30,50,5,2,63,38,3,1000,-1:-1,hex,show,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"