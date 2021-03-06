#!/bin/sh

numb='1411'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 20 --keyint 200 --lookahead-threads 2 --min-keyint 20 --qp 50 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.6,1.2,1.4,0.5,0.6,0.5,1,0,16,20,200,2,20,50,4,1,62,28,1,1000,-2:-2,hex,show,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"