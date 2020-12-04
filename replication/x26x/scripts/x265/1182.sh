#!/bin/sh

numb='1183'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 1.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 15 --keyint 210 --lookahead-threads 1 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.5,1.2,1.4,0.2,0.9,0.9,3,0,8,15,210,1,21,0,4,0,68,28,4,2000,-2:-2,dia,crop,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"