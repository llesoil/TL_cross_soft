#!/bin/sh

numb='1542'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 1.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 50 --keyint 200 --lookahead-threads 3 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 1 --qpmax 62 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset fast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.3,1.3,1.4,0.3,0.8,0.5,1,2,12,50,200,3,28,20,5,1,62,38,4,2000,1:1,dia,show,fast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"