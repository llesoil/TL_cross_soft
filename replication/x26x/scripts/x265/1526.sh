#!/bin/sh

numb='1527'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 1.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 25 --keyint 240 --lookahead-threads 2 --min-keyint 30 --qp 0 --qpstep 3 --qpmin 2 --qpmax 61 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.5,1.6,1.1,1.8,0.6,0.8,0.6,1,2,2,25,240,2,30,0,3,2,61,48,6,2000,-2:-2,dia,show,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"