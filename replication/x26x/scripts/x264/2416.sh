#!/bin/sh

numb='2417'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 1.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 15 --keyint 220 --lookahead-threads 0 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.4,1.1,1.4,0.4,0.9,0.1,3,1,16,15,220,0,26,20,4,1,65,38,3,2000,1:1,dia,show,slower,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"