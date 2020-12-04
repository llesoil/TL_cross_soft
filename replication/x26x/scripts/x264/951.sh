#!/bin/sh

numb='952'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 1.6 --qblur 0.2 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 10 --keyint 290 --lookahead-threads 4 --min-keyint 29 --qp 40 --qpstep 5 --qpmin 2 --qpmax 66 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset slower --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.4,1.1,1.6,0.2,0.6,0.1,1,1,6,10,290,4,29,40,5,2,66,38,1,2000,1:1,hex,show,slower,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"