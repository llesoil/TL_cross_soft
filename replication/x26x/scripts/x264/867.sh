#!/bin/sh

numb='868'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 2.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 50 --keyint 250 --lookahead-threads 3 --min-keyint 26 --qp 40 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset superfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.4,1.1,2.8,0.2,0.7,0.0,0,1,2,50,250,3,26,40,4,3,63,18,5,1000,-2:-2,dia,show,superfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"