#!/bin/sh

numb='1884'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 2.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 50 --keyint 270 --lookahead-threads 1 --min-keyint 29 --qp 30 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset placebo --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.3,1.3,2.0,0.4,0.8,0.8,0,2,12,50,270,1,29,30,5,0,66,18,1,2000,-2:-2,dia,crop,placebo,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"