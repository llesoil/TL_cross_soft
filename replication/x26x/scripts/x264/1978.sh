#!/bin/sh

numb='1979'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 1.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 45 --keyint 280 --lookahead-threads 0 --min-keyint 25 --qp 50 --qpstep 3 --qpmin 0 --qpmax 62 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.6,1.3,1.6,0.6,0.9,0.5,3,1,6,45,280,0,25,50,3,0,62,28,2,2000,-2:-2,dia,show,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"