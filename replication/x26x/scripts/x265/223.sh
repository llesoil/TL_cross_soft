#!/bin/sh

numb='224'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 30 --keyint 260 --lookahead-threads 2 --min-keyint 22 --qp 50 --qpstep 4 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset veryslow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.4,1.2,1.4,0.3,0.7,0.7,2,0,0,30,260,2,22,50,4,4,67,48,3,2000,-2:-2,dia,show,veryslow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"