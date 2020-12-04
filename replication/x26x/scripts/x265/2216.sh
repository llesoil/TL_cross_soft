#!/bin/sh

numb='2217'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 2.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 15 --keyint 290 --lookahead-threads 1 --min-keyint 27 --qp 40 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.0,1.3,1.2,2.6,0.3,0.9,0.0,0,1,2,15,290,1,27,40,4,2,67,48,6,1000,-2:-2,hex,show,veryfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"