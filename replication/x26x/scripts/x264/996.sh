#!/bin/sh

numb='997'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 3.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.9 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 35 --keyint 230 --lookahead-threads 2 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.5,1.2,3.8,0.2,0.8,0.9,0,2,0,35,230,2,28,40,5,1,63,28,1,1000,1:1,hex,show,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"