#!/bin/sh

numb='3018'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 4.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 50 --keyint 260 --lookahead-threads 3 --min-keyint 28 --qp 30 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.6,1.4,4.8,0.4,0.6,0.5,2,2,16,50,260,3,28,30,4,1,62,28,2,1000,-1:-1,hex,show,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"