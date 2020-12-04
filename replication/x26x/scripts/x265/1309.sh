#!/bin/sh

numb='1310'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.2 --qblur 0.4 --qcomp 0.8 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 20 --keyint 200 --lookahead-threads 0 --min-keyint 22 --qp 20 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.2,1.2,1.2,0.4,0.8,0.2,3,1,0,20,200,0,22,20,5,4,66,48,2,2000,-2:-2,umh,show,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"