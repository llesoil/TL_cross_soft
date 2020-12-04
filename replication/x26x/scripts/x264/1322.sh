#!/bin/sh

numb='1323'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 3.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.9 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 20 --keyint 280 --lookahead-threads 0 --min-keyint 29 --qp 40 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.5,1.3,1.3,3.2,0.3,0.7,0.9,2,0,0,20,280,0,29,40,5,0,67,28,2,1000,-2:-2,dia,show,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"