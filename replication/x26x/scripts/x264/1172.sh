#!/bin/sh

numb='1173'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 1.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 45 --keyint 250 --lookahead-threads 2 --min-keyint 21 --qp 20 --qpstep 3 --qpmin 0 --qpmax 69 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset placebo --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.1,1.2,1.4,0.3,0.8,0.5,3,0,12,45,250,2,21,20,3,0,69,38,1,1000,1:1,hex,crop,placebo,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"