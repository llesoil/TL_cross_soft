#!/bin/sh

numb='2088'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 4.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 35 --keyint 210 --lookahead-threads 2 --min-keyint 22 --qp 50 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset veryslow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.3,1.2,4.4,0.6,0.8,0.8,1,0,16,35,210,2,22,50,3,4,65,28,5,2000,-2:-2,umh,show,veryslow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"