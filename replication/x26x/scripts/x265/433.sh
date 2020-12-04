#!/bin/sh

numb='434'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 0.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 4 --crf 20 --keyint 210 --lookahead-threads 0 --min-keyint 26 --qp 50 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset medium --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.0,1.3,1.3,0.8,0.5,0.6,0.3,1,2,4,20,210,0,26,50,5,0,64,48,4,1000,1:1,hex,show,medium,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"