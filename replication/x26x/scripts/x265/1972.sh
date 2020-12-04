#!/bin/sh

numb='1973'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 0.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 25 --keyint 240 --lookahead-threads 2 --min-keyint 20 --qp 20 --qpstep 3 --qpmin 3 --qpmax 68 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.4,1.0,0.2,0.6,0.6,0.9,3,0,2,25,240,2,20,20,3,3,68,38,4,1000,1:1,umh,show,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"