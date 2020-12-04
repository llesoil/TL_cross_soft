#!/bin/sh

numb='1070'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 4.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 45 --keyint 230 --lookahead-threads 3 --min-keyint 22 --qp 10 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset superfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,2.0,1.4,1.3,4.4,0.5,0.7,0.4,1,0,16,45,230,3,22,10,3,4,62,18,6,1000,-2:-2,hex,crop,superfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"