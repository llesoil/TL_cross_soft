#!/bin/sh

numb='1169'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 5.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 25 --keyint 300 --lookahead-threads 1 --min-keyint 20 --qp 40 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.3,1.0,5.0,0.4,0.6,0.1,0,2,0,25,300,1,20,40,4,3,61,28,1,2000,-2:-2,dia,show,medium,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"