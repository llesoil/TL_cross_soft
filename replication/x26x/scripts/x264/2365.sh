#!/bin/sh

numb='2366'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 1.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 5 --keyint 210 --lookahead-threads 0 --min-keyint 28 --qp 10 --qpstep 3 --qpmin 4 --qpmax 66 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.5,1.4,1.8,0.5,0.9,0.6,0,1,12,5,210,0,28,10,3,4,66,48,5,1000,-2:-2,hex,show,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"